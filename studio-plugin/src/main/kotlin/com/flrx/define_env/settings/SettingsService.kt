package com.flrx.define_env.settings

import com.intellij.openapi.components.PersistentStateComponent
import com.intellij.openapi.components.Service
import com.intellij.openapi.components.State
import com.intellij.openapi.components.Storage
import com.intellij.openapi.project.Project

@Service
@State(name = "DefineEnvMap", storages = [Storage("define_env.xml")])
class SettingsService : PersistentStateComponent<SettingsState> {

    companion object {
        fun getInstance(project: Project): SettingsService = project.getService(SettingsService::class.java)
    }

    private var settingsState = SettingsState()

    override fun getState() = settingsState

    override fun loadState(state: SettingsState) {
        settingsState = state
    }
}