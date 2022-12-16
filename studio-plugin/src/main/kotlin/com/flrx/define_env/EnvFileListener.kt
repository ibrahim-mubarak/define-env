package com.flrx.define_env

import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.roots.ProjectFileIndex
import com.intellij.openapi.vfs.AsyncFileListener
import com.intellij.openapi.vfs.newvfs.events.VFileEvent

class EnvFileListener : AsyncFileListener {

    override fun prepareChange(events: MutableList<out VFileEvent>): AsyncFileListener.ChangeApplier {
        val envFileEvents = events.filter { isValidEvent(it) }

        return OnFileChangedProcessor(envFileEvents)
    }
}

fun isValidEvent(event: VFileEvent): Boolean {
    val file = event.file ?: return false
    if (!file.exists()) return false
    if (!event.isFromSave && !event.isFromRefresh) return false
    if (!event.path.contains(".env")) return false


    var isInOpenProject = false

    val openProjects = ProjectManager.getInstance().openProjects

    for (project in openProjects) {
        if (ProjectFileIndex.getInstance(project).isInContent(file)) {
            isInOpenProject = true
        }
    }

    if (!isInOpenProject) {
        return false
    }

    return true
}
