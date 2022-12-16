package com.flrx.define_env

import com.flrx.define_env.utils.getProjects
import com.intellij.openapi.progress.ProgressManager
import com.intellij.openapi.vfs.AsyncFileListener
import com.intellij.openapi.vfs.newvfs.events.VFileEvent

class OnFileChangedProcessor(private val events: List<VFileEvent>) : AsyncFileListener.ChangeApplier {


    override fun afterVfsChange() = events
        .mapNotNull { it.file }
        .forEach { file ->
            file.getProjects().forEach { project ->
                ProgressManager.getInstance().run(DefineEnvForProjectTask(file, project))
            }
        }
}