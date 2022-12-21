package com.flrx.define_env.tool

import com.intellij.execution.RunManagerEx
import com.intellij.execution.configurations.RunConfiguration
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.DialogWrapper
import com.intellij.openapi.ui.ComboBox
import io.flutter.run.FlutterRunConfigurationType
import java.awt.BorderLayout
import javax.swing.*
import javax.swing.event.ListDataListener

class RunConfigurationChooserDialog(project: Project) : DialogWrapper(project) {
    private val configurationComboBox = ComboBox<RunConfiguration>()
    private val panel = JPanel(BorderLayout())

    init {
        title = "Choose Run Configuration"
        setOKButtonText("Choose")
        setCancelButtonText("Cancel")
        val configs = RunManagerEx.getInstanceEx(project).allConfigurationsList.filter {
            it.type is FlutterRunConfigurationType
        }

        configurationComboBox.model = object : ComboBoxModel<RunConfiguration> {
            var selectedItem: RunConfiguration? = null

            override fun getSize() = configs.size

            override fun getElementAt(index: Int) = configs[index]

            override fun addListDataListener(l: ListDataListener?) {
                //
            }

            override fun removeListDataListener(l: ListDataListener?) {
                //
            }

            override fun setSelectedItem(anItem: Any?) {
                selectedItem = anItem as RunConfiguration?
            }

            override fun getSelectedItem(): Any {
                return selectedItem ?: ""
            }

        }

        panel.add(configurationComboBox, BorderLayout.CENTER)
        init()
    }

    override fun createCenterPanel(): JComponent = panel

    val selectedConfiguration: RunConfiguration?
        get() = configurationComboBox.selectedItem as? RunConfiguration
}
