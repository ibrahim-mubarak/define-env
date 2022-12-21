package com.flrx.define_env.tool

import com.flrx.define_env.model.DefineEnvModel
import com.flrx.define_env.model.RunConfigDetails
import com.intellij.util.ui.ColumnInfo
import com.intellij.util.ui.ListTableModel


class FileRunConfigurationTableModel :
    ListTableModel<DefineEnvModel>(
        IsEnabledColumn(),
        FileColumn(),
        RunConfigurationColumn()
    )

class IsEnabledColumn : ColumnInfo<DefineEnvModel, Boolean>("Enabled") {
    override fun valueOf(p0: DefineEnvModel?): Boolean? {
        return p0?.isEnabled
    }
}

class FileColumn : ColumnInfo<DefineEnvModel, String>("Env File") {
    override fun valueOf(p0: DefineEnvModel?): String? {
        return p0?.file
    }
}

class RunConfigurationColumn : ColumnInfo<DefineEnvModel, RunConfigDetails>("Run Configuration") {
    override fun valueOf(p0: DefineEnvModel?): RunConfigDetails? {
        return p0?.runConfiguration
    }
}
