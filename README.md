# Disposable PowerShell Module by Cody Konior

There is no logo yet.

[![Build status](https://ci.appveyor.com/api/projects/status/9vavuweyhs0aa740?svg=true)](https://ci.appveyor.com/project/codykonior/disposable)

There is no CHANGELOG yet.

## Description
Objects which own unmanaged resources (such as network connections and SQL Server
database connections) should have their Dispose method called in order to free up
those connections and so the object's memory can later be released in a timely manner.

New-DisposableObject provides a simple way of managing this using a simple syntax
usually consisting of the instantiation of the object followed by a scriptblock in
which it will be used, before being disposed of behind the scenes.

## Installation

- `Install-Module Disposable`

## Major functions

- `New-DisposableObject`
- `New-ComObject` (experimental version for COM objects)

## Tips

- Be careful about variable scope, whatever you define within the block will
  disappear afterwards, and changes to variables outside of the block may
  require a `$script:` prefix

## Demo

There is no demo yet.

## Further Examples

``` powershell
New-DisposableObject ($dataSet = New-Object System.Data.DataSet) {
    # ... Your code here
}
```

[1]: Images/cim.ai.svg
[2]: Images/cim.gif
[3]: CHANGELOG.md
