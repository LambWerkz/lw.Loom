# Creates module-scoped ConcurrentDictionary, this is where the runspace pools will be stored. This function is idempotent, so it can be called multiple times without issue.
function Initialize-LoomPoolRegistry {
    if ($Script:LoomPoolRegistry) {
        if ($Script:LoomPoolRegistry -isnot [System.Collections.Concurrent.ConcurrentDictionary[string, object]]) {
            throw 'LoomPoolRegistry exists but is not the expected type.'
        }

        return $Script:LoomPoolRegistry
    }

    $Script:LoomPoolRegistry = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
    return $Script:LoomPoolRegistry
}
