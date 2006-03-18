*** /usr/include/InsightToolkit/BasicFilters/itkChangeLabelImageFilter.h.orig	2006-01-20 13:17:08.000000000 +0100
--- /usr/include/InsightToolkit/BasicFilters/itkChangeLabelImageFilter.h	2006-01-20 13:17:19.000000000 +0100
***************
*** 68,74 ****
      m_ChangeMap[original] = result; 
    }
    
!   void SetChangeMap( ChangeMapType & changeMap )
    { 
      m_ChangeMap = changeMap; 
    }
--- 68,74 ----
      m_ChangeMap[original] = result; 
    }
    
!   void SetChangeMap( const ChangeMapType & changeMap )
    { 
      m_ChangeMap = changeMap; 
    }
