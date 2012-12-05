add_executable ( example_test "test_suite.cpp" )

add_test ( example_test example_test )

target_link_libraries ( example_test example )
