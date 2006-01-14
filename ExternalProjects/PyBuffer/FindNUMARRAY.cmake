# Try to find numarray python package
# Once done this will define
#
# PYTHON_NUMARRAY_FOUND        - system has numarray development package and it should be used
# PYTHON_NUMARRAY_INCLUDE_DIR  - directory where the arrayobject.h header file can be found
#
#

  FIND_PATH(PYTHON_NUMARRAY_INCLUDE_DIR arrayobject.h
    /usr/include/python2.4/numarray/
    /usr/include/python2.3/numarray/
    /usr/include/python2.2/numarray/
    /usr/include/python2.1/numarray/
    DOC "Directory where the arrayobject.h header file can be found. This file is part of the numarray package"
    )

  IF(PYTHON_NUMARRAY_INCLUDE_DIR)
    SET (PYTHON_NUMARRAY_FOUND 1 CACHE INTERNAL "Python numarray development package is available")
  ENDIF(PYTHON_NUMARRAY_INCLUDE_DIR)

