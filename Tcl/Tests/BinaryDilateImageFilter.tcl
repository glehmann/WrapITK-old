#
#  Example on the use of the BinaryDilateImageFilter
#
package require InsightToolkit

set reader [ itkImageFileReaderIUS2_New ]

set filter [ itkBinaryDilateImageFilterIUS2IUS2_New ]

set cast [ itkCastImageFilterIUS2IUC2_New ]

set writer [ itkImageFileWriterIUC2_New ]

$filter     SetInput [ $reader  GetOutput ]
$cast     SetInput [ $filter  GetOutput ]
$writer     SetInput [ $cast  GetOutput ]

$reader SetFileName [lindex $argv 0]
$writer SetFileName [lindex $argv 1]

itkBinaryBallStructuringElementB2  element 

element  SetRadius 5
element  CreateStructuringElement

$filter SetKernel  element 
$filter SetDilateValue 200

$writer Update


exit

