<#

.SYNOPSIS
The equivalent of C# using for PowerShell.

.DESCRIPTION
Objects which own unmanaged resources (such as network connections and SQL Server
database connections) should have their Dispose method called in order to free up
those connections and so the object's memory can later be released in a timely
manner.

New-DisposableObject provides a simple way of managing this using a simple syntax
usually consisting of the instantiation of the object followed by a scriptblock in
which it will be used, before being disposed of behind the scenes.

.PARAMETER DisposableObject
An object which implements System.IDisposable. This is most likely an expression;
see the example.

.PARAMETER ScriptBlock
A script block during which the above object will be used, and after which the
object should be disposed of.

.EXAMPLE
Creating a disposable object, disposing it, then showing it's empty.

Import-Module DisposableObject -DisableNameChecking

New-DisposableObject ($northwind = Restore-LinqSchema Northwind | Connect-LinqSchema) { 
	Take-Linq -LinqObject $northwind.DataContext.Orders 1 -Evaluate
} 
$northwind.DataContext
# Shows empty

.EXAMPLE
Showing the effects of variables within the script block.

Import-Module Disposable -DisableNameChecking
$var = "ABC"

"Variable is $var."
New-DisposableObject ($northwind = Restore-LinqSchema Northwind | Connect-LinqSchema) { 
    $var = "BCD"
    "Variable set to $var inside the dispose statement."
} 
"Variable is $var after the dispose statement."

New-DisposableObject ($northwind = Restore-LinqSchema Northwind | Connect-LinqSchema) { 
    $script:var = "BCD"
    "Script variable set to $var inside the second dispose statement."
} 
"Script variable is $var after the second dispose statement."

.NOTES
Care must be taken not to modify variables within the scriptblock which exist in the outer
scope. If you must do so, those variables must use a $script: prefix, otherwise your change
may be lost as shown in the second example.

This function is based largely on work done by Adam Weigert @ http://weblogs.asp.net/adweigert/powershell-adding-the-using-statement

#>

function New-DisposableObject {
    param (
        [System.IDisposable] 
        $DisposableObject,
        [ScriptBlock] 
        $ScriptBlock
    )
    
    if ($DisposableObject) {
        try {
            &$scriptBlock
        } finally {
            if ($DisposableObject -ne $null) {
                if ($DisposableObject.psbase -eq $null) {
                    $DisposableObject.Dispose()
                } else {
                    $DisposableObject.psbase.Dispose()
                }
            }
        }
    }
}
