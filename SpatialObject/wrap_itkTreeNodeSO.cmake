WRAP_CLASS("TreeNode" POINTER)
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_SO${d}}" "${ITKT_SO${d}}*")
  ENDFOREACH(d)
END_WRAP_CLASS()
