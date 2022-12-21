package com.flrx.define_env.utils

import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

fun Process.readOutput(): String {
    val reader = InputStreamReader(inputStream)
    val br = BufferedReader(reader)

    var line: String?
    var finalString = ""
    while (br.readLine().also { line = it } != null) {
        // process each line of output from the command
        finalString += line
    }
    return finalString
}

fun Process.readError(): String {
    // read the error output from the process
    val reader = InputStreamReader(errorStream)
    val br = BufferedReader(reader)
    val sb = StringBuilder()
    var line: String?
    while (br.readLine().also { line = it } != null) {
        // append each line of output to the StringBuilder
        sb.append(line).append("\n")
    }

    return sb.toString()
}

fun ProcessBuilder.addPathToEnv(path:String) {
    environment()["PATH"] = path + File.pathSeparator +environment()["PATH"]
}