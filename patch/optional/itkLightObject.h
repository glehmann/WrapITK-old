*** itk/Insight/Code/Common/itkLightObject.h	2006-01-07 15:09:45.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkLightObject.h	2005-10-24 13:50:52.000000000 +0200
***************
*** 106,111 ****
--- 106,113 ----
     * method, use it with care. */
    virtual void SetReferenceCount(int);
  
+   const char * __str__() const;
+   
  protected:
    LightObject():m_ReferenceCount(1) {}
    virtual ~LightObject(); 
