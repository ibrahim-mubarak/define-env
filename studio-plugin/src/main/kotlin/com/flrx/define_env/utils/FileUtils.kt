package com.flrx.define_env.utils

import com.intellij.openapi.project.Project
import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.roots.ProjectFileIndex
import com.intellij.openapi.vfs.VirtualFile

fun VirtualFile.getProjects(): List<Project> {
    val openProjects = ProjectManager.getInstance().openProjects

    return openProjects.filter { ProjectFileIndex.getInstance(it).isInContent(this) }
}
