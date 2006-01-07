*** itk/Insight/Code/Common/itkLightObject.cxx	2006-01-07 15:17:15.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkLightObject.cxx	2005-10-24 13:50:52.000000000 +0200
***************
*** 115,121 ****
    this->PrintTrailer(os, indent);
  }
  
! 
  /**
   * This method is called when itkExceptionMacro executes. It allows 
   * the debugger to break on error.
--- 115,128 ----
    this->PrintTrailer(os, indent);
  }
  
! const char * LightObject::__str__() const
! {
!   OStringStream msg;
!   this->Print(msg);
!   return msg.str().c_str();
! }
!    
!    
  /**
   * This method is called when itkExceptionMacro executes. It allows 
   * the debugger to break on error.
