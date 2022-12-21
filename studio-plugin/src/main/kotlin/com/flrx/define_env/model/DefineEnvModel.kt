package com.flrx.define_env.model

import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.util.xmlb.annotations.XMap
import io.flutter.run.SdkRunConfig
import java.io.File

data class DefineEnvModel(
    var isEnabled: Boolean?,
    var file: String?,
    var runConfiguration: RunConfigDetails?
) {

    constructor() : this(null, null, null)

    constructor(project: Project, isEnabled: Boolean, file: VirtualFile, runConfiguration: SdkRunConfig) :
            this(
                isEnabled,
                file.path.replace(project.basePath + File.separator, ""),
                RunConfigDetails(runConfiguration.name, runConfiguration.type.displayName)
            )
}
