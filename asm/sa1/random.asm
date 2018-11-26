; 32-bit Random Number Generator for SA-1.
; Read output at !rand + 0..3

!m_w = $3780
!m_z = $3784
!rand = $3788

random:
	PHP				;
	SEP #$20			;
	STZ.w $2250			; Set Multiply Mode
	REP #$20			; 16-bit Accum
	
	LDA.w #36969			;\ 36969 * (m_z & 65535)
	STA.w $2251			; |
	LDA.w !m_z			; |
	STA.w $2253			;/
	CLC				;\ m_z = 36969 * (m_z & 65535) + (m_z >> 16)
	BRA $00				; |
	LDA.w $2306			; |
	ADC.w !m_z+2			; |
	STA.w !m_z			; |
	LDA.w $2308			; |
	ADC.w #$0000			; |
	STA.w !m_z+2			;/
					;
	LDA.w #18000			;\ 18000 * (m_w & 65535)
	STA.w $2251			; |
	LDA.w !m_w			; |
	STA.w $2253			;/
	CLC				;\ m_z = 18000 * (m_w & 65535) + (m_w >> 16)
	BRA $00				; |
	LDA.w $2306			; |
	ADC.w !m_w+2			; |
	STA.w !m_w			; |
	LDA.w $2308			; |
	ADC.w #$0000			; |
	STA.w !m_w+2			;/
					;
	LDA.w !m_w+2			;\ high = (m_w >> 16) + (m_z & 65535)
	CLC				; |
	ADC.w !m_z			; |
	STA.w !rand+2			;/
	LDA.w !m_w			;\ low = m_w
	STA.w !rand			;/
	PLP				;
	RTL				; result = high << 16 | low
