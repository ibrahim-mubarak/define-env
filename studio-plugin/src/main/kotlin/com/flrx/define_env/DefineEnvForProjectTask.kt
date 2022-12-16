package com.flrx.define_env

import com.flrx.define_env.utils.addPathToEnv
import com.flrx.define_env.utils.readError
import com.flrx.define_env.utils.readOutput
import com.google.common.base.Joiner
import com.intellij.execution.RunManagerEx
import com.intellij.execution.RunnerAndConfigurationSettings
import com.intellij.openapi.progress.ProgressIndicator
import com.intellij.openapi.progress.Task
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.vfs.VirtualFile
import com.jetbrains.lang.dart.sdk.DartSdk
import io.flutter.run.FlutterRunConfigurationType
import io.flutter.run.SdkRunConfig
import java.io.File

class DefineEnvForProjectTask(
    private val file: VirtualFile,
    private val project: Project,
) : Task.Backgroundable(project, "Updating Dart Define") {
    private lateinit var indicator: ProgressIndicator

    override fun run(indicator: ProgressIndicator) {
        this.indicator = indicator
        if (!indicator.isRunning) {
            indicator.start()
        }
        runDefineEnvForProject()
        indicator.stop()
    }

    private fun runDefineEnvForProject(): Boolean {
        indicator.text = "Starting Process"
        val pb = buildDefineEnvProcess()


        // start the process
        indicator.text = "Running Process"
        val process = pb.start()

        // read the output from the process
        var processOutput = process.readOutput()

        // wait for the process to finish
        val finalCode = process.waitFor()

        return when {
            finalCode != 0 -> {
                val message = process.readError()

                println(message)
                Messages.showInfoMessage(message, "Dart Define Error")
                false
            }

            else -> {
                indicator.text = "Updating Configurations"
                updateConfigurationsForProject(project, processOutput)
                true
            }
        }
    }

    private fun buildDefineEnvProcess(): ProcessBuilder {
        /// Build Process
        val pb = ProcessBuilder("dart", "pub", "global", "run", "define_env", "-f", file.path)

        /// Run in Project directory
        println(file.path)
        println(project.basePath)
        pb.directory(File(project.basePath))

        /// Update Path Env
        pb.addPathToEnv(System.getenv("PATH"))

        /// Add Dart SDK to PATH

        val dartSdkPath = DartSdk.getDartSdk(project)?.homePath
        println(dartSdkPath ?: "No SDK Found for project")

        val dartSdkBinPath = dartSdkPath + File.separator + "bin"
        pb.addPathToEnv(dartSdkBinPath)

        return pb
    }


    private fun updateConfigurationsForProject(project: Project, dartDefineString: String) {
        RunManagerEx.getInstanceEx(project).allSettings
            .filter { it.configuration.type is FlutterRunConfigurationType }
            .forEach { checkSettings(it, dartDefineString) }
    }

    private fun checkSettings(setting: RunnerAndConfigurationSettings, defineString: String) {
        val configuration = setting.configuration as? SdkRunConfig
        val fields = configuration!!.fields

        var oldArgs = (fields.additionalArgs ?: "")

        var retainedArgs = oldArgs
            .replace("&quot;", "\"")
            .replace(Regex("""--dart-define=[^ "]+(["\'])([^"\'])+(["\'])"""), "")
            .replace(Regex("""--dart-define=[^ "]+"""), "")
            .replace(Regex("\\s+"), " ")
            .trim()

        var args = mutableListOf<String>()

        if (!retainedArgs.isNullOrBlank()) {
            args.add(retainedArgs)
        }

        args.add(defineString)

        var finalArgs = Joiner.on(" ").join(args)
        fields.additionalArgs = finalArgs
    }
}