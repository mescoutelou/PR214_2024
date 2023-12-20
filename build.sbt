/*
 * File: build.sbt                                                             *
 * Created Date: 2023-02-25 01:11:34 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2023-12-20 03:19:15 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


// ******************************
//           PARAMETERS
// ******************************
ThisBuild / scalaVersion     := "2.13.10"
ThisBuild / version          := "0.1.0"
ThisBuild / organization     := "herdware"
val chiselVersion = "5.0.0"

val libDep = Seq(
  "org.chipsalliance" %% "chisel" % chiselVersion,
  "edu.berkeley.cs" %% "chiseltest" % "5.0.0" % "test"
)

val scalacOpt = Seq(
  //"-Xsource:2.13",
  "-language:reflectiveCalls",
  "-deprecation",
  "-feature",
  "-Xcheckinit",
  "-Ymacro-annotations"
  // Enables autoclonetype2 in 3.4.x (on by default in 3.5)
  //"-P:chiselplugin:useBundlePlugin"
  //"-P:chiselplugin:genBundleElements"
)

// ******************************
//           PROJECTS
// ******************************
lazy val main = (project in file("."))
  .settings(
    name := "main",
    libraryDependencies ++= libDep,
    scalacOptions ++= scalacOpt,
    addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
  )
