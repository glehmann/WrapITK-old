*** itk/Insight/Code/SpatialObject/itkSpatialObject.h	2006-01-07 15:10:17.000000000 +0100
--- itk-mima2/Insight/Code/SpatialObject/itkSpatialObject.h	2005-10-24 13:51:34.000000000 +0200
***************
*** 394,400 ****
  
    /** Return a raw pointer to the node container */
    typename TreeNodeType::Pointer GetTreeNode() {return m_TreeNode;}
!   typename TreeNodeType::ConstPointer GetTreeNode() const {return m_TreeNode;}
  
    /** Theses functions are just calling the AffineGeometryFrame functions */
    /** Set the spacing of the spatial object. */
--- 394,400 ----
  
    /** Return a raw pointer to the node container */
    typename TreeNodeType::Pointer GetTreeNode() {return m_TreeNode;}
!   //typename TreeNodeType::ConstPointer GetTreeNode() const {return m_TreeNode;}
  
    /** Theses functions are just calling the AffineGeometryFrame functions */
    /** Set the spacing of the spatial object. */
