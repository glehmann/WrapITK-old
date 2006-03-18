*** itk/Insight/Code/SpatialObject/itkSpatialObjectTreeNode.h	2006-01-07 15:09:47.000000000 +0100
--- itk-mima2/Insight/Code/SpatialObject/itkSpatialObjectTreeNode.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 77,82 ****
--- 77,87 ----
  
    TransformPointer m_NodeToParentNodeTransform;
    TransformPointer m_NodeToWorldTransform;
+    
+ private:
+      SpatialObjectTreeNode(const Self&); //purposely not implemented
+      void operator=(const Self&); //purposely not implemented
+    
  };
  
  /** Constructor */
