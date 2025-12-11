# Wrapper script to run cleanup with automatic confirmation
$confirmationResponse = "yes"

# Create a temporary input stream
$inputString = [System.IO.StringReader]::new($confirmationResponse)
$oldInputIn = [Console]::In
[Console]::SetIn($inputString)

try {
    # Run the cleanup script
    & D:\workspace\fluxdype\cleanup_duplicate_models.ps1
}
finally {
    [Console]::SetIn($oldInputIn)
    $inputString.Dispose()
}
