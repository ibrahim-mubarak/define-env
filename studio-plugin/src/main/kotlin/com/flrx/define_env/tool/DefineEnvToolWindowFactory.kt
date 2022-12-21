package com.flrx.define_env.tool

import com.intellij.openapi.project.Project
import com.intellij.openapi.wm.ToolWindow
import com.intellij.openapi.wm.ToolWindowFactory

class DefineEnvToolWindowFactory : ToolWindowFactory {
    override fun createToolWindowContent(project: Project, toolWindow: ToolWindow) {
        val toolWindowPanel = DefineEnvToolWindow(project)
        val contentManager = toolWindow.contentManager
        val content = contentManager.factory.createContent(toolWindowPanel, null, false)

        contentManager.addContent(content)
    }
}
