if(EXISTS "${PROJECT_SOURCE_DIR}/.gitmodules")
message("-- Updating submodules to their latest/fixed versions")

### set the direcory where the submodules live
set(GIT_SUBMODULES_DIRECTORY vendor)

### set the directory names of the submodules
set(GIT_SUBMODULES serialization testing)

### set each submodules's commit or tag that is to be checked out
### (leave empty if you want master)
set(GIT_SUBMODULE_VERSION_serialization v0.9.0)
set(GIT_SUBMODULE_VERSION_testing       4f8c51c)

### First, get all submodules in
execute_process(
    COMMAND             git submodule update --init --recursive
    WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}
)

### Then, checkout each submodule to the specified commit
# Note: Execute separate processes here, to make sure each one is run,
# should one crash (because of branch not existing, this, that ... whatever)
foreach(GIT_SUBMODULE ${GIT_SUBMODULES})
    if( "${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}}" STREQUAL "" )
        message("-- no specific version given for submodule ${GIT_SUBMODULE}, checking out master")
        set(GIT_SUBMODULE_VERSION_${GIT_SUBMODULE} "master")
    endif()

    message("-- checking out ${GIT_SUBMODULE}'s commit/tag ${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}}")

    execute_process(
        COMMAND             git checkout master
        WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}/${GIT_SUBMODULES_DIRECTORY}/${GIT_SUBMODULE}
        OUTPUT_QUIET
        ERROR_QUIET
    )
    execute_process(
        COMMAND             git branch -D ${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}}
        WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}/${GIT_SUBMODULES_DIRECTORY}/${GIT_SUBMODULE}
        OUTPUT_QUIET
        ERROR_QUIET
    )
    execute_process(
        COMMAND             git checkout -b ${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}}
        WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}/${GIT_SUBMODULES_DIRECTORY}/${GIT_SUBMODULE}
        OUTPUT_QUIET
        ERROR_QUIET
    )
    execute_process(
        COMMAND             git rev-parse --abbrev-ref HEAD 
        COMMAND             sed "s,heads/,,"
        OUTPUT_VARIABLE     RESULT
        WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}/${GIT_SUBMODULES_DIRECTORY}/${GIT_SUBMODULE}
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(${RESULT} MATCHES "^${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}}$")
        message("-- checking out ${GIT_SUBMODULE}'s commit/tag ${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}} successful.")
    else()
        message("-- checking out ${GIT_SUBMODULE}'s commit/tag ${GIT_SUBMODULE_VERSION_${GIT_SUBMODULE}} failed.")
    endif()

endforeach(${GIT_SUBMODULE})

endif()