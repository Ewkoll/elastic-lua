return {
    Version = {
        --[[
            used to indicate the write operation should succeed regardless of current version
        --]]
        MATCH_ANY = -3,
        --[[
            indicates that the current document was not found in lucene and in the version map
        --]]
        NOT_FOUND = -2,
        --[[
            sed to indicate that the write operation should be executed if the document is currently deleted
            i.e., not found in the index and/or found as deleted (with version) in the version map
        --]]
        MATCH_DELETED = -4
    },
    VersionType = {
        INTERNAL = "internal"
    },
    Result = {
        CREATED = "created",
        UPDATED = "updated",
        DELETED = "deleted"
    },
    EnumResult = {
        CREATED = 0,
        UPDATED = 1,
        DELETED = 2,
        NOT_FOUND = 3,
        NOOP = 4
    }
}
