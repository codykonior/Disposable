<#

.SYNOPSIS
The equivalent of C# using for PowerShell.

.DESCRIPTION
Calls dispose on an object after the script block is complete.

.PARAMETER DisposableObject
An object which implements System.IDisposable.

.PARAMETER ScriptBlock
A script block.

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
Originally written by http://weblogs.asp.net/adweigert/powershell-adding-the-using-statement

If you are changing variables in the outer scope, the easiest method is to add a $script: prefix, otherwise your changes may be lost as shown in the second example.

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
