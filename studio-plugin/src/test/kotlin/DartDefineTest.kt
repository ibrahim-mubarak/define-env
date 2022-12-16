import com.google.common.base.Joiner
import org.junit.Test
import kotlin.test.expect

class DartDefineTest {

    @Test
    fun testDartDefineTest(): Unit {
        var sample = """--release --dart-define=APP_ENV=staging2 --dart-define=APP_SUFFIX=.staging2 --dart-define=APP_NAME="My App staging2""""
        var newDartString = """--dart-define=APP_ENV=staging --dart-define=APP_SUFFIX=.staging --dart-define=APP_NAME="My App staging""""
        var expectedString = """--release --dart-define=APP_ENV=staging --dart-define=APP_SUFFIX=.staging --dart-define=APP_NAME="My App staging""""

        expect(expectedString) {
            var retainedArgs = sample
                .replace("&quot;", "\"")
                .replace(Regex("""--dart-define=[^ "]+(["\'])([^"\'])+(["\'])"""), "")
                .replace(Regex("""--dart-define=[^ "]+"""), "")
                .replace(Regex("\\s+"), " ")
                .trim()

            var args = mutableListOf<String>()

            if(!retainedArgs.isNullOrBlank()) {
                args.add(retainedArgs)
            }

            args.add(newDartString)

            val finalString = Joiner.on(" ").join(args)

            finalString
        }
    }
}