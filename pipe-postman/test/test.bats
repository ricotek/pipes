#!/usr/bin/env bats

setup() {
  DOCKER_IMAGE=${DOCKER_IMAGE:="test/pipe-terraform"}

  echo "Building image..."
  docker build -t ${DOCKER_IMAGE}:test .
}

@test "Test Fixture Success" {
    run docker run \
        -v $(pwd)/test/fixture/success:$(pwd) \
        -w $(pwd) \
        -e PSSCRIPTRACE="2" \
        -e TFENVIRONMENT="baz" \
        -e TFACTION="validate" \
        -e TFBACKENDBUCKET="TEST" \
        -e TFBACKENDREGION="TEST" \
        -e TFNOINITBACKEND="true" \
        ${DOCKER_IMAGE}:test

    echo "Status: $status"
    echo "Output: $output"

    [ "$status" -eq 0 ]
}

@test "Test Fixture Failure" {
    run docker run \
        -v $(pwd)/test/fixture/failure:$(pwd) \
        -w $(pwd) \
        -e PSSCRIPTRACE="2" \
        -e TFENVIRONMENT="baz" \
        -e TFACTION="validate" \
        -e TFBACKENDBUCKET="TEST" \
        -e TFBACKENDREGION="TEST" \
        -e TFNOINITBACKEND="true" \
        ${DOCKER_IMAGE}:test

    echo "Status: $status"
    echo "Output: $output"

    [ "$status" -eq 1 ]
}
