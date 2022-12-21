package com.flrx.define_env

import com.flrx.define_env.exceptions.DartSdkException
import com.flrx.define_env.exceptions.ProjectPathException
import com.flrx.define_env.model.DefineEnvModel
import com.flrx.define_env.settings.SettingsService
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
import kotlin.io.path.Path

class DefineEnvForProjectTask(
    private val file: VirtualFile,
    private val project: Project,
) : Task.Backgroundable(project, "Updating dart define configuration") {
    private lateinit var indicator: ProgressIndicator

    private val service = SettingsService.getInstance(project)
    override fun run(indicator: ProgressIndicator) {
        this.indicator = indicator


        val filePathFromProjectRoot: String = file.path.replace(project.basePath + File.separator, "")

        val properConfigs = service.state.envRunConfigs.filter {
            return@filter it.file == filePathFromProjectRoot
        }

        println(properConfigs)

        if (properConfigs.isEmpty()) {
            return
        }

        if (!indicator.isRunning) {
            indicator.start()
        }

        properConfigs.forEach {
            runDefineEnvForConfig(it)
        }
        indicator.stop()
    }

    private fun runDefineEnvForConfig(model: DefineEnvModel): Boolean {
        indicator.text = "Starting process"
        val pb = buildDefineEnvProcess()


        // start the process
        indicator.text = "Running process"
        val process = pb.start()

        // read the output from the process
        val processOutput = process.readOutput()

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
                indicator.text = "Updating configurations"
                updateConfigurations(model, processOutput)
                true
            }
        }
    }

    private fun buildDefineEnvProcess(): ProcessBuilder {
        /// Build Process
        /// Add Dart SDK to PATH
        val dartSdkPath = DartSdk.getDartSdk(project)?.homePath ?: throw DartSdkException()

        val dartSdkBinPath = dartSdkPath + File.separator + "bin"
        val dartBinary = Path(dartSdkPath, "bin", "dart").toString()

        val pb = ProcessBuilder(dartBinary, "pub", "global", "run", "define_env", "-f", file.path)

        val projectPath = project.basePath ?: throw ProjectPathException()

        /// Run in Project directory
        pb.directory(File(projectPath))

        /// Update Path Env
        pb.addPathToEnv(System.getenv("PATH"))
        pb.addPathToEnv(dartSdkBinPath)

        return pb
    }


    private fun updateConfigurations(model: DefineEnvModel, dartDefineString: String) {
        RunManagerEx.getInstanceEx(project).allSettings
            .filter { it.configuration.type is FlutterRunConfigurationType }
            .filter { model.runConfiguration!!.name == it.configuration.name }
            .forEach { checkSettings(it, dartDefineString) }
    }

    private fun checkSettings(setting: RunnerAndConfigurationSettings, defineString: String) {
        val configuration = setting.configuration as? SdkRunConfig
        val fields = configuration!!.fields

        val oldArgs = (fields.additionalArgs ?: "")

        val retainedArgs = oldArgs
            .replace("&quot;", "\"")
            .replace(Regex("""--dart-define=[^ "]+(["\'])([^"\'])+(["\'])"""), "")
            .replace(Regex("""--dart-define=[^ "]+"""), "")
            .replace(Regex("\\s+"), " ")
            .trim()

        val args = mutableListOf<String>()

        if (retainedArgs.isNotBlank()) {
            args.add(retainedArgs)
        }

        args.add(defineString)

        val finalArgs = Joiner.on(" ").join(args)
        fields.additionalArgs = finalArgs
    }
}