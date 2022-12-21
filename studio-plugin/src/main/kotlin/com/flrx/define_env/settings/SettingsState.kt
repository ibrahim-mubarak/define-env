package com.flrx.define_env.settings

import com.flrx.define_env.model.DefineEnvModel

data class SettingsState(var envRunConfigs: MutableList<DefineEnvModel> = mutableListOf())