package ioio;

import ioio.lib.api.DigitalInput;
import ioio.lib.api.DigitalOutput;
import ioio.lib.api.IOIO;


public class IOPin 
{
	private int m_pin;
	private int m_pinMode=0; // 0=none, 1=digitalOut, 2=analogOut, 3=digitalIn, 4=analogIn
	private DigitalOutput.Spec.Mode m_digitalOutputMode = DigitalOutput.Spec.Mode.NORMAL;
	private DigitalInput.Spec.Mode m_digitalInputMode = DigitalInput.Spec.Mode.FLOATING;
	private int m_value = 1;
	private boolean m_invalidateSetup = true;
	
	private DigitalOutput m_digitalOutput = null;
	private DigitalInput  m_digitalInput = null;
	
	public IOPin(int i_pin)
	{
		m_pin = i_pin;
	}
	
	public void setPinMode(String i_pinMode, String i_mode)
	{
		if (i_pinMode.indexOf("digitalOut")!=-1)
		{
			if (m_pinMode!=1)
			{
				m_pinMode = 1;
				m_invalidateSetup = true;
			}
			
			if (i_mode.indexOf("normal")!=-1)
			{
				if (m_digitalOutputMode != DigitalOutput.Spec.Mode.NORMAL)
				{
					m_digitalOutputMode = DigitalOutput.Spec.Mode.NORMAL;
					m_invalidateSetup = true;
				}
			}
			else if (i_mode.indexOf("open_drain")!=-1)
			{
				if (m_digitalOutputMode != DigitalOutput.Spec.Mode.OPEN_DRAIN)
				{
					m_digitalOutputMode = DigitalOutput.Spec.Mode.OPEN_DRAIN;
					m_invalidateSetup = true;
				}
			}
		}
		else if (i_pinMode.indexOf("digitalIn")!=-1)
		{
			if (m_pinMode!=2)
			{
				m_pinMode = 2;
				m_invalidateSetup = true;
			}
			
			if (i_mode.indexOf("floating")!=-1)
			{
				if (m_digitalInputMode != DigitalInput.Spec.Mode.FLOATING)
				{
					m_digitalInputMode = DigitalInput.Spec.Mode.FLOATING;
					m_invalidateSetup = true;
				}
			}
			else if (i_mode.indexOf("pull_down")!=-1)
			{
				if (m_digitalInputMode != DigitalInput.Spec.Mode.PULL_DOWN)
				{
					m_digitalInputMode = DigitalInput.Spec.Mode.PULL_DOWN;
					m_invalidateSetup = true;
				}
			}
			else if (i_mode.indexOf("pull_up")!=-1)
			{
				if (m_digitalInputMode != DigitalInput.Spec.Mode.PULL_UP)
				{
					m_digitalInputMode = DigitalInput.Spec.Mode.PULL_UP;
					m_invalidateSetup = true;
				}
			}
		}
		else
		{
			m_pinMode = 0;
		}
	}
	
	public int getValue()
	{
		return m_value;
	}
	
	public void setValue(int i_value)
	{
		m_value = i_value;
	}
	
	public void setup(IOIO i_ioio, boolean i_force)
	{
		try
		{
			if (i_force)
			{
				m_invalidateSetup = true;
			}
			
			if (m_invalidateSetup)
			{
				m_invalidateSetup = false;
				
				if (m_digitalOutput!=null)
				{
					m_digitalOutput.close();
					m_digitalOutput = null;
				}
				if (m_digitalInput!=null)
				{
					m_digitalInput.close();
					m_digitalInput = null;
				}
				
				
				switch(m_pinMode)
				{
					case 0:
						break;
					case 1: 
						m_digitalOutput = i_ioio.openDigitalOutput(m_pin, m_digitalOutputMode, (m_value==0 ? false : true));
						break;
					case 2: 
						m_digitalInput = i_ioio.openDigitalInput(m_pin, m_digitalInputMode);
						break;
						
				}
			}
		}
		catch(Exception e)
		{
			
		}
	}
	
	
	
	public boolean update()
	{
		boolean modified = false;
		try
		{
			switch(m_pinMode)
			{
				case 1: 
					if (m_digitalOutput!=null)
					{
						m_digitalOutput.write((m_value==0 ? false : true));
					}
					break;
					
				case 2: 
					if (m_digitalInput!=null)
					{
						int value = m_digitalInput.read() ? 1 : 0;
						modified = (m_value != value);
						m_value = value;
						
					}
					break;
			}
		}
		catch(Exception e)
		{
			
		}

		return modified;
	}
}
