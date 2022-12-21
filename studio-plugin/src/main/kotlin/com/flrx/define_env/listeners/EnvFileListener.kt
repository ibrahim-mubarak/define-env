package com.flrx.define_env.listeners

import com.flrx.define_env.DefineEnvForProjectTask
import com.flrx.define_env.utils.getProjects
import com.intellij.openapi.progress.ProgressManager
import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.roots.ProjectFileIndex
import com.intellij.openapi.vfs.AsyncFileListener
import com.intellij.openapi.vfs.AsyncFileListener.ChangeApplier
import com.intellij.openapi.vfs.newvfs.events.VFileEvent

class EnvFileListener : AsyncFileListener {
    override fun prepareChange(events: MutableList<out VFileEvent>): AsyncFileListener.ChangeApplier {
        val envFileEvents = events.filter { isValidEvent(it) }

        return object : ChangeApplier {
            override fun afterVfsChange() = envFileEvents
                .mapNotNull { it.file }
                .forEach { file ->
                    file.getProjects().forEach { project ->
                        ProgressManager.getInstance().run(DefineEnvForProjectTask(file, project))
                    }
                }
        }
    }

    private fun isValidEvent(event: VFileEvent): Boolean {
        val file = event.file ?: return false
        if (!file.exists()) return false
        if (!event.isFromSave && !event.isFromRefresh) return false
        if (!event.path.contains(".env")) return false


        val openProjects = ProjectManager.getInstance().openProjects

        val isInOpenProject = openProjects.fold(false) { prev, project ->
            return prev || ProjectFileIndex.getInstance(project).isInContent(file)
        }

        return isInOpenProject
    }
}


