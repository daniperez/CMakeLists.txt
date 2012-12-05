#include <boost_time.hpp>
 
boost::posix_time::ptime get_boost_time ()
{
  return boost::posix_time::second_clock::universal_time();
}
