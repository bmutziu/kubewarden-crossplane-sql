#!/usr/bin/env bats

 @test "reject because name is on deny list" {
   run kwctl run annotated-policy.wasm -r test_data/sql.json --settings-json '{"allowed_sizes": ["medium", "large"]}'

   # this prints the output when one the checks below fails
   echo "output = ${output}"

   # request rejected
   [ "$status" -eq 0 ]
   [ $(expr "$output" : '.*allowed.*false') -ne 0 ]
   [ $(expr "$output" : ".*The 'my-db' name is not on the allowed size list.*") -ne 0 ]
 }

@test "accept because name is on the allow list" {
  run kwctl run annotated-policy.wasm -r test_data/sql.json --settings-json '{"allowed_sizes": ["small"]}'
  # this prints the output when one the checks below fails
  echo "output = ${output}"

  # request accepted
  [ "$status" -eq 0 ]
  [ $(expr "$output" : '.*allowed.*true') -ne 0 ]
}

@test "accept because the allow list is empty" {
  run kwctl run annotated-policy.wasm -r test_data/sql.json
  # this prints the output when one the checks below fails
  echo "output = ${output}"

  # request accepted
  [ "$status" -eq 0 ]
  [ $(expr "$output" : '.*allowed.*true') -ne 0 ]
}
