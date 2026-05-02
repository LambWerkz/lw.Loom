# AST parser for $using: scope extraction
function Resolve-LoomUsingVariables {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,

        [Parameter(Mandatory)]
        [System.Management.Automation.SessionState]$SessionState,

        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInvocationIntrinsics]$InvokeCommand
    )

    $scriptText = $ScriptBlock.ToString()
    $normalizedScriptBlock = [scriptblock]::Create($scriptText)
    $usingExpressions = @(
        $normalizedScriptBlock.Ast.FindAll(
            { param($ast) $ast -is [System.Management.Automation.Language.UsingExpressionAst] },
            $true
        )
    )

    if ($usingExpressions.Count -eq 0) {
        return [pscustomobject]@{
            ScriptText        = $scriptText
            UsingVariables    = [ordered]@{}
            HasUsingVariables = $false
        }
    }

    $usingVariables = [ordered]@{}
    $replacements = New-Object System.Collections.Generic.List[object]

    for ($index = 0; $index -lt $usingExpressions.Count; $index++) {
        $usingExpression = [System.Management.Automation.Language.UsingExpressionAst]$usingExpressions[$index]
        $variableName = "__loomUsing_$index"
        $replacementText = '$' + $variableName
        $expressionText = $usingExpression.SubExpression.Extent.Text -replace '^\$using:', '$'

        $subExpressionVariable = $usingExpression.SubExpression -as [System.Management.Automation.Language.VariableExpressionAst]
        if ($subExpressionVariable -and $subExpressionVariable.Splatted) {
            $replacementText = '@' + $variableName
            $expressionText = $usingExpression.SubExpression.Extent.Text -replace '^@using:', '$'
        }

        $probeText = "[pscustomobject]@{ Value = $expressionText }"

        try {
            $probe = [scriptblock]::Create($probeText)
            $probeResult = $InvokeCommand.InvokeScript($SessionState, $probe, @())
            $valueProperty = $probeResult[0].PSObject.Properties['Value']
            $usingVariables[$variableName] = $valueProperty.Value
        }
        catch {
            throw "Failed to resolve using expression '$($usingExpression.Extent.Text)': $($_.Exception.Message)"
        }

        $null = $replacements.Add([pscustomobject]@{
                Start       = $usingExpression.Extent.StartOffset
                End         = $usingExpression.Extent.EndOffset
                Replacement = $replacementText
            })
    }

    $rewrittenScriptText = $scriptText
    foreach ($replacement in $replacements | Sort-Object Start -Descending) {
        $rewrittenScriptText =
            $rewrittenScriptText.Substring(0, $replacement.Start) +
            $replacement.Replacement +
            $rewrittenScriptText.Substring($replacement.End)
    }

    [pscustomobject]@{
        ScriptText        = $rewrittenScriptText
        UsingVariables    = $usingVariables
        HasUsingVariables = $true
    }
}
