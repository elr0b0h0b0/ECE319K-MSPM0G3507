################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
Clock.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/Clock.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Dump.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/Dump.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.o: ../%.s $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.o: ../%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

LaunchPad.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/LaunchPad.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Timer.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/Timer.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

UART.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/UART.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

UARTbusywait.o: C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/inc/UARTbusywait.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-armllvm_3.2.1.LTS/bin/tiarmclang.exe" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug" -I"C:/ti/mspm0_sdk_1_10_00_05/source/third_party/CMSIS/Core/Include" -I"C:/ti/mspm0_sdk_1_10_00_05/source" -D__MSPM0G3507__ -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)" -I"C:/Users/r0b0h/code/TI_MSPM0/MSPM0_ValvanoWare/ECE319K_Lab2/Debug/syscfg" -std=c99 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


