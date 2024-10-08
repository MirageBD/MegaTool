; -----------------------------------------------------------------------------------------------

.feature pc_assignment
.feature labels_without_colons
.feature c_comments

; -----------------------------------------------------------------------------------------------

.segment "DECRZEROINIT"

			.word basicend
			.word 0										; 0
			.byte $fe, $02								; bank
			.byte $30									; 0
			.byte $3a									; :
			.byte $9e									; sys xxxx
			.byte .sprintf("%d", $2011)					; sys xxxx
			.byte 0
basicend	.byte 0
			.byte 0

			jmp :+
debugbreak
			ldx #$37
			stx $01
			inc $d020
			jmp *-3
:

			sei

			lda #$35
			sta $01

			lda #$00										; unmap
			tax
			tay
			taz
			map
			eom

			lda #$70										; Disable C65 rom protection using hypervisor trap (see mega65 manual)
			sta $d640
			eom

			lda #%11111000									; unmap c65 roms $d030 by clearing bits 3-7
			trb $d030

			sta $d707										; copy colour ram to safe area
			.byte $80, ($ff80000 >> 20)						; source megabyte
			.byte $81, ($ff80800 >> 20)						; dest megabyte
			.byte $00										; end of job options
			.byte $00										; copy
			.word 2048										; count
			.word ($ff80000 & $ffff)						; src
			.byte (($ff80000 >> 16) & $0f)					; src bank and flags
			.word ($ff80800 & $ffff)						; dst
			.byte (($ff80800 >> 16) & $0f)					; dst bank and flags
			.byte $00										; cmd hi
			.word $0000										; modulo, ignored

			lda #<2048										; set (offset!) pointer to colour ram
			sta $d064
			lda #>2048
			sta $d065

			sta $d707										; inline DMA copy
			.byte $00										; end of job options
			.byte $00										; copy
dc_transferlen
			.word $0000										; count
dc_transferfrom
			.word $0000										; src
			.byte $00										; src bank and flags
dc_transferto
			.word $0000										; dst
			.byte $00										; dst bank and flags
			.byte $00										; cmd hi
			.word $0000										; modulo, ignored

decruncherlength
			ldx #$00-$08
:			;lda $10-1,x
			;sta $c000-1,x
			lda decruncher-1,x
			sta $08-1,x
			dex
			bne :-

dc_depackfrom
			lda #$00
			sta $04
			lda #$00
			sta $05
			lda #$00
			sta $06
			lda #$00
			sta $07

			clc
			lda #$80
			sta $02

			jmp $0008

decruncher
			; decruncher to be moved to $0008
