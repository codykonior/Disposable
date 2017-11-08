<#

.SYNOPSIS
Dispose disposable variables, the equivalent of C# using for PowerShell.

.DESCRIPTION
Objects which own unmanaged resources (such as network connections and SQL Server database connections) should have their Dispose method called in order to free up those connections and so the object's memory can later be released in a timely manner.

New-DisposableObject provides a simple way of managing this using a simple syntax usually consisting of the instantiation of the object followed by a scriptblock in which it will be used, before being disposed of behind the scenes.

.PARAMETER DisposableObject
An object which implements System.IDisposable. This is most likely an expression; see the example.

.PARAMETER ScriptBlock
A script block during which the above object will be used, and after which the object should be disposed of.

.EXAMPLE
New-DisposableObject ($dataSet = New-Object System.Data.DataSet) {
}

Disposes of $dataSet.

.EXAMPLE
# Try 1
$var = "ABC"
"Before: Var is $var"
New-DisposableObject ($dataSet = New-Object System.Data.DataSet) { 
    $var = "BCD"
    "During: Var is $var"
} 
"After: Var is $var"
# Try 2
"Before: Var is $var"
New-DisposableObject ($dataSet = New-Object System.Data.DataSet) { 
    $script:var = "BCD"
    "During: Var is $var"
} 
"After: Var is $var"

Showing the effects of variables within the scriptblock.

.NOTES
Care must be taken not to modify variables within the scriptblock which exist in the outer scope. If you must do so, those variables must use a $script: prefix, otherwise your change may be lost as shown in the second example.

This function is based largely on work done by Adam Weigert @ http://weblogs.asp.net/adweigert/powershell-adding-the-using-statement

#>

function New-ComObject {
    param (
        [System.__ComObject] 
        $DisposableObject,
        [ScriptBlock] 
        $ScriptBlock
    )
    
    if ($DisposableObject) {
        try {
            &$ScriptBlock
        } finally {
            if ($null -ne $DisposableObject) {
                [System.Runtime.InteropServices.Marshal]::ReleaseComObject($DisposableObject)
            }
        }
    }
}
