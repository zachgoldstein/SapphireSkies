package sound
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	
	import org.generalrelativity.thread.process.AbstractProcess;
	
	public class SoundEffectProcess extends AbstractProcess
	{
		
		public var _snyth:SfxrSynth;
		public var e:SampleDataEvent
		
		public function SoundEffectProcess(snyth:SfxrSynth, event:SampleDataEvent, isSelfManaging:Boolean=false)
		{
			super(isSelfManaging);
			e = event;
			_snyth = snyth;
			
		}
		
		override public function run():void
		{
			
			if(_snyth._waveData)
			{
				if(_snyth._waveDataPos + _snyth._waveDataBytes > _snyth._waveDataLength) _snyth._waveDataBytes = _snyth._waveDataLength - _snyth._waveDataPos;
				
				if(_snyth._waveDataBytes > 0) e.data.writeBytes(_snyth._waveData, _snyth._waveDataPos, _snyth._waveDataBytes);
				
				_snyth._waveDataPos += _snyth._waveDataBytes;
			}
			else
			{	
				var length:uint;
				var i:uint, l:uint;
				
				if (_snyth._mutation)
				{
					if (_snyth._original)
					{
						_snyth._waveDataPos = _snyth._cachedMutation.position;
						
						if (_snyth.synthWave(_snyth._cachedMutation, 3072, true))
						{
							_snyth._params.copyFrom(_snyth._original);
							_snyth._original = null;
							
							_snyth._cachingMutation++;
							
							if ((length = _snyth._cachedMutation.length) < 24576)
							{
								// If the sound is smaller than the buffer length, add silence to allow it to play
								_snyth._cachedMutation.position = length;
								for(i = 0, l = 24576 - length; i < l; i++) _snyth._cachedMutation.writeFloat(0.0);
							}
							
							if (_snyth._cachingMutation >= _snyth._cachedMutationsNum)
							{
								_snyth._cachingMutation = -1;
							}
						}
						
						_snyth._waveDataBytes = _snyth._cachedMutation.length - _snyth._waveDataPos;
						
						e.data.writeBytes(_snyth._cachedMutation, _snyth._waveDataPos, _snyth._waveDataBytes);
					}
				}
				else
				{
					if (_snyth._cachingNormal)
					{
						_snyth._waveDataPos = _snyth._cachedWave.position;
						
						if (_snyth.synthWave(_snyth._cachedWave, 3072, true))
						{
							if ((length = _snyth._cachedWave.length) < 24576)
							{
								// If the sound is smaller than the buffer length, add silence to allow it to play
								_snyth._cachedWave.position = length;
								for(i = 0, l = 24576 - length; i < l; i++) _snyth._cachedWave.writeFloat(0.0);
							}
							
							_snyth._cachingNormal = false;
							_snyth.dispatchEvent(new Event(Event.SOUND_COMPLETE));
						}
						
						_snyth._waveDataBytes = _snyth._cachedWave.length - _snyth._waveDataPos;
						
						e.data.writeBytes(_snyth._cachedWave, _snyth._waveDataPos, _snyth._waveDataBytes);
					}
				}
			}			
		}
	}
}