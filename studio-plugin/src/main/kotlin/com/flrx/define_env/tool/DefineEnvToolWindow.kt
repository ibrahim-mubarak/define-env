package com.flrx.define_env.tool

import com.flrx.define_env.model.DefineEnvModel
import com.flrx.define_env.settings.SettingsService
import com.intellij.execution.configurations.RunConfiguration
import com.intellij.ide.util.TreeFileChooserFactory
import com.intellij.openapi.fileTypes.FileTypes
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.DialogWrapper
import com.intellij.openapi.ui.SimpleToolWindowPanel
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.ui.ToolbarDecorator
import com.intellij.ui.components.JBScrollPane
import com.intellij.ui.table.TableView
import io.flutter.run.SdkRunConfig
import java.awt.BorderLayout

class DefineEnvToolWindow(val project: Project) : SimpleToolWindowPanel(true, true) {

    private val settingsService = SettingsService.getInstance(project)
    private val tableModel = FileRunConfigurationTableModel()
    private val table = TableView(tableModel)

    init {
        setupUi()
        initializeTableModel()
    }

    private fun initializeTableModel() {
        tableModel.addRows(settingsService.state.envRunConfigs)
        tableModel.addTableModelListener {
            settingsService.state.envRunConfigs = tableModel.items
        }
    }

    private fun setupUi() {
        val toolbarDecorator: ToolbarDecorator = ToolbarDecorator.createDecorator(table)
        toolbarDecorator.setAddAction { startAddRowFlow() }

        val scrollPane = JBScrollPane(table)

        layout = BorderLayout()
        add(toolbarDecorator.createPanel(), BorderLayout.NORTH)
        add(scrollPane, BorderLayout.CENTER)
    }


    private fun startAddRowFlow() {
        val selectedFile = selectEnvFile() ?: return
        val runConfiguration = selectConfiguration() ?: return

        // Add the selected file to the table
        tableModel.addRow(DefineEnvModel(project, true, selectedFile, runConfiguration as SdkRunConfig))
    }

    private fun selectEnvFile(): VirtualFile? {
        val treeFileChooserFactory = TreeFileChooserFactory.getInstance(project)
        val fileChooser = treeFileChooserFactory
            .createFileChooser(
                "Choose Env File",
                null,
                FileTypes.PLAIN_TEXT,
                { return@createFileChooser it.name.contains(".env") },
                true
            )

        fileChooser.showDialog()

        return when (fileChooser.selectedFile) {
            null -> null
            else -> fileChooser.selectedFile!!.virtualFile
        }
    }

    private fun selectConfiguration(): RunConfiguration? {
        val chooserDialog = RunConfigurationChooserDialog(project)
        chooserDialog.show()

        return when {
            chooserDialog.exitCode != DialogWrapper.OK_EXIT_CODE -> null
            else -> chooserDialog.selectedConfiguration
        }
    }
}
