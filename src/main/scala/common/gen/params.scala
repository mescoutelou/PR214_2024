/*
 * File: example.scala                                                         *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2023-12-21 07:27:31 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.gen

import chisel3._
import chisel3.util._
import scala.math._


trait GenParams {
  def isSim: Boolean
}

case class GenConfig (
  isSim: Boolean
) extends GenParams