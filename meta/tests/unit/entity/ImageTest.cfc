component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	
	public void function setUp() {
		super.setup();

		
  	variables.entity = request.slatwallScope.newEntity( 'Image' );

	}
	
	public void function getResizedImageTest(){
		var imageData={
		   	imageID=''
		              };
		              
	var mockImage = createTestEntity('Image',imageData);
		var result= mockImage.getResizedImage();
		request.debug(result);            
	  }
	  
	  public void function getImagePathTest()
	  {
	  	var imageData={
	  		imageID='', 
	  		imageName="sample", 
	  		directory="sampleDirectory"
  		};
  		var settingData={
  			settingID='', settingName='globalAssetsImageFolderPath', settingValue='sunny/iWannaGoHere'
  		};
  		var checkOutput= 'sunny/iWannaGoHere/sampleDirectory/sudoku.jpg';
  		var mockSetting= createPersistedTestEntity('Setting',settingData );
  		var mockImage= createTestEntity('Image', imageData);
  		mockImage.setImageFile("sudoku.jpg");
  		
  		var result=mockImage.getImagePath();
  		assertEquals(checkOutput, result);
  	    
  	    
  	    var fakeOutput='sunny/iDontWannaGoHere/sampleDirectory/sudoku.jpg';
  	  
  	    assertNotEquals(fakeOutput,result);	
  	    
	  	}
	  	
	  	
	  	public void function getImageExtensionTest()
	  	{
	  	var imageData= {
	  		imageID=''
	  	};
	  	var mockImage= createTestEntity('Image', imageData);	
	  	mockImage.setImageFile("sunny.jpg");
	  	var result= mockImage.getImageExtension();
	  	expectedResult= "jpg";
	  	assertEquals(expectedResult, result );
	  	
	  	assertNotEquals("abc",result);
	  	}
	  	public void function getResizedImagePathTest(){
	  		
		var imageData={
		   	imageID=''
		              };
		              
	var mockImage = createTestEntity('Image',imageData);
		var result= mockImage.getResizedImagePath();
		     request.debug(result); 
	  		
	  	}
  }
	