package ioio;


import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import android.app.Activity;
import ioio.lib.api.exception.ConnectionLostException;
import ioio.lib.util.BaseIOIOLooper;
import ioio.lib.util.IOIOLooper;
import ioio.lib.util.IOIOLooperProvider;
import ioio.lib.util.android.IOIOAndroidApplicationHelper;

public class MyIO  implements IOIOLooperProvider
{
	private FREContext m_freContext;
	private IOIOAndroidApplicationHelper m_ioioHelper = null;
	private boolean m_invalidateSetup = false;
	
	private IOPin[] m_ioPins = new IOPin[50];

	
	public MyIO()
	{
		for(int i=0;i<40;i++)
		{
			m_ioPins[i] = new IOPin(i);
		}
	}
	
 	public IOIOLooper createIOIOLooper(String connectionType, Object extra) 
    {
    	Looper looper = new Looper();
    	return looper;
    }
 
 	
 	public void initContext(FREContext i_freContext)
 	{
 		m_freContext = i_freContext;
 	}
 	

 	public void dispose()
 	{
 		try
 		{
 			m_ioioHelper.stop();
 		}
 		catch(Exception e)
 		{
 		}
 	}
 	
 	
 	public FREObject setIOPin(FREArray i_param)
 	{
 		FREObject ret = null;
 		try
 		{
 			int pinId = i_param.getObjectAt(0).getAsInt();
 			IOPin ioPin = m_ioPins[pinId];
 			String pinMode = i_param.getObjectAt(1).getAsString();
 			String digitalOutputMode = i_param.getObjectAt(2).getAsString();
 			
			ioPin.setPinMode(pinMode, digitalOutputMode);
 		}
 		catch(Exception e)
 		{
 			
 		}
 		
 		return ret;
 		
 	}
 	
 	public FREObject invalidateSetup(FREArray i_param)
 	{
 		FREObject ret = null;
 		try
 		{ 
 			if (m_ioioHelper==null)
 			{
	 			Activity activity = m_freContext.getActivity();
	 			m_ioioHelper = new IOIOAndroidApplicationHelper(activity, this);
	 			m_ioioHelper.create();
	 			m_ioioHelper.start();
 			}
 			else
 			{
 				m_invalidateSetup = true;
 			}
 			ret = FREObject.newObject("initIO");
 		}
 		catch(Exception e) 
 		{
 			try
 			{
 				ret = FREObject.newObject(e.getMessage());
 			}
 			catch(Exception e2)
 			{
 				
 			}
 		}
 		
 		return ret;
 	}
 	
 	public FREObject writeIO(FREArray i_param)
 	{
 		FREObject ret = null;
 		try
 		{
 			int pinId = i_param.getObjectAt(0).getAsInt();
 			IOPin ioPin = m_ioPins[pinId];
 			int value = i_param.getObjectAt(1).getAsInt();
 			ioPin.setValue(value);
 			ret = FREObject.newObject("write");
 		}
 		catch(Exception e)
 		{
 			try
 			{
 				ret = FREObject.newObject(e.getMessage());
 			}
 			catch(Exception e2)
 			{
 				
 			}
 		}
 		
 		return ret;
 	}
 	
 
 	public FREObject readIO(FREArray i_param)
 	{
 		FREObject ret = null;
 		try
 		{
 			FREArray array = FREArray.newArray(40);
 			for(int i=0;i<40;i++)
			{
				IOPin ioPin = m_ioPins[i];
				int value = ioPin.getValue();
				
				array.setObjectAt(i,  FREObject.newObject(value));
			}   			
 			ret = array;
 		}
 		catch(Exception e)
 		{
 		}
 		
 		return ret;
 	}
 
 	
    public class Looper extends BaseIOIOLooper 
    {
    	/**
    	 * Called every time a connection with IOIO has been established.
    	 * Typically used to open pins.
    	 * 
    	 * @throws ConnectionLostException
    	 *             When IOIO connection is lost.
    	 * 
    	 * @see ioio.lib.util.AbstractIOIOActivity.IOIOThread#setup()
    	 */
    	@Override
    	protected void setup() throws ConnectionLostException 
    	{
    		setIOPins(true);
    	}
    	
    	private void setIOPins(boolean i_force)
    	{
    		for(int i=0;i<40;i++)
			{
				IOPin ioPin = m_ioPins[i];
				ioPin.setup(ioio_, i_force);
			}    		
    	}

    	/**
    	 * Called repetitively while the IOIO is connected.
    	 * 
    	 * @throws ConnectionLostException
    	 *             When IOIO connection is lost.
    	 * 
    	 * @see ioio.lib.util.AbstractIOIOActivity.IOIOThread#loop()
    	 */
    	@Override
    	public void loop() throws ConnectionLostException 
    	{
			try 
			{
				Thread.sleep(100);
				
				if (m_invalidateSetup)
				{
					m_invalidateSetup = false;
					setIOPins(false);
				}
				 
				boolean modified = false;
				ioio_.beginBatch();
				for(int i=0;i<40;i++)
				{
					IOPin ioPin = m_ioPins[i];
					modified = (modified || ioPin.update());
				}
				ioio_.endBatch();
				
				if (modified)
				{
					m_freContext.dispatchStatusEventAsync("A1", "status");
				}
				
			} 
			catch (InterruptedException e) 
			{
				
			}

    	}

    }
}
