package com.flrx.define_env.model

data class RunConfigDetails(var name: String? = null, var type: String? = null) {
    override fun toString() = name ?: super.toString()
}