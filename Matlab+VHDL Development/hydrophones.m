function [tdoa1,tdoa2,tdoa3]=hydrophones(in1,in2,in3,in4)
  persistent real;
  persistent imag;
  persistent max_time;
  persistent max_amplitude;
  persistent max_phase;
  persistent iter;
  alpha = .99;
  beta = .01;
  out = zeros(3);
  frequency=25000;
  sine_wave_size = 200;
  sampling_rate = 200000;
  window = 1996000;
  threshold = 0;
  if isempty(iter)
    iter = 0;
  end
  if isempty(real)
    real = zeros(4);
  end
  if isempty(imag)
     imag = zeros(4); 
  end
  if isempty(max_time)
     max_time=0;
  end
  if isempty(max_amplitude)
     max_amplitude=-1;
  end
  if isempty(max_phase)
      max_phase = zeros(4);
  end
  
  in = [in1 in2 in3 in4];
  
  time = iter * 1000000 / sampling_rate;
  
  microrevs = mod((frequency * time),1000000);
  wave_idx = microrevs * sine_wave_size / 1000000;
  for c=1:4 
     real(c) = real(c) * alpha + in(c) * sin(wave_idx) * beta;
     imag(c) = imag(c) * alpha - in(c) * cos(wave_idx) * beta;
  end
  
  if (time > window) 
     if time < max_time
         max_time = 0;
     end
     min_amplitude = 100;
     
     for c=1:4 
        amplitude = real(c) * real(c) + imag(c) * imag(c);
        if amplitude < min_amplitude 
            min_amplitude = amplitude;
        end
     end

     if (min_amplitude > max_amplitude) 
       max_amplitude = min_amplitude;
       max_time = time;
       for c = 1:4
         y = abs(imag(c));
         x = abs(real(c));
         max_phase(c) = atan2(y, x);
         if x < 0 && y == 0
             max_phase(c) = pi;
         end
         if y < 0 && x == 0
             max_phase(c) = -pi/2;
         end
         if x < 0 && y > 0
             max_phase(c) = max_phase(c) + pi;
         end
         if x < 0 && y < 0 
             max_phase(c) = max_phase(c) - 2*pi;
         end
         if x > 0 && y < 0
              max_phase(c) = max_phase(c) - pi;
         end
       end
     end
     if time - max_time >= window && max_amplitude >= threshold 
        base_phase = max_phase(1);
        for c = 2:4 
          phase_shift = max_phase(3) - base_phase;

          if phase_shift < -pi
              phase_shift = phase_shift+ 2 * pi;
          end
          if phase_shift >= pi
              phase_shift = phase_shift - 2 * pi;
          end
          time_diff = phase_shift / (2 * pi * frequency) * 1000000;
          out(c-1)=time_diff;
        end

        max_amplitude = -1;
        max_time = time;

        for c = 1:4
          real(c) = 0;
          imag(c) = 0;
        end
     end
  end
  iter=iter+1;
  tdoa1=out(1);
  tdoa2=out(2);
  tdoa3=out(3);
end
