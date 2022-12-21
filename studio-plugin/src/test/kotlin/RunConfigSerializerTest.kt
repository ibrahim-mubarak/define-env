import com.fasterxml.jackson.dataformat.xml.XmlMapper
import com.flrx.define_env.model.DefineEnvModel
import com.intellij.openapi.project.ex.ProjectEx
import com.intellij.openapi.roots.ProjectRootManager
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.openapi.vfs.VirtualFileManager
import com.intellij.openapi.vfs.VirtualFileSystem
import com.intellij.psi.PsiFile
import com.intellij.psi.impl.PsiFileEx
import com.intellij.testFramework.fixtures.BasePlatformTestCase
import io.flutter.run.FlutterRunConfigurationType
import io.flutter.run.SdkRunConfig
import org.junit.Test
import java.io.File
import kotlin.io.path.Path

class RunConfigSerializerTest : BasePlatformTestCase() {


    @Test
    fun testRunConfigSerialization(): Unit {
        val factory = FlutterRunConfigurationType.Factory(FlutterRunConfigurationType())
        var tempConfig = factory.createTemplateConfiguration(project)

        val runConfiguration = factory.createConfiguration("Flutter for Test", tempConfig) as SdkRunConfig

        var projectFile = File(project.basePath + File.separator + ".env")
        projectFile.createNewFile()

        var file = VirtualFileManager.getInstance().findFileByNioPath(Path(projectFile.path))!!

        project.save()

        var pathFromProjectRoot = file.path.replace(project.basePath + File.separator, "")

        println(pathFromProjectRoot)

        val model = DefineEnvModel(project, true, file, runConfiguration)

        val mapper = XmlMapper()

        val xmlString = mapper.writeValueAsString(model)
        println(xmlString)


//        val fromXml = mapper.readValue(xmlString, DefineEnvModel::class.java)
//        println(fromXml.runConfiguration?.name)
    }

}