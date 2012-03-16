#include <boost_time.hpp>
#include <time.h>

int main ( int argc, char** argv )
{
  boost::posix_time::ptime posix_time
    = boost::posix_time::from_time_t ( time(NULL) ) -
      boost::posix_time::minutes ( 1 );
  
  boost::posix_time::ptime boost_time
    = get_boost_time();

  if ( posix_time > boost_time )
  {
    std::cerr << "test failed: posix_time > boost_time" << std::endl;
    return -1;
  }
  else
  {
    return 0;
  }
}
