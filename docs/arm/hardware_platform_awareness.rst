ARM64 Hardware Platform Awareness
=================================

This document describes Arm64 specific features for HPA


1. ARM64 ELF hwcaps
-------------------
The majority of hwcaps are intended to indicate the presence of features
which are described by architected ID registers inaccessible to
userspace code at EL0. These hwcaps are defined in terms of ID register
fields, and should be interpreted with reference to the definition of
these fields in the ARM Architecture Reference Manual.

HWCAP_FP
    Floating-point.
    Functionality implied by ID_AA64PFR0_EL1.FP == 0b0000.

HWCAP_ASIMD
    Advanced SIMD.
    Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0000.

HWCAP_EVTSTRM
    The generic timer is configured to generate events at a frequency of
    approximately 100KHz.

HWCAP_AES
    Advanced Encryption Standard.
    Functionality implied by ID_AA64ISAR1_EL1.AES == 0b0001.

HWCAP_PMULL
    Polynomial multiply long (vector)
    Functionality implied by ID_AA64ISAR1_EL1.AES == 0b0010.

HWCAP_SHA1
    SHA1 hash update accelerator.
    Functionality implied by ID_AA64ISAR0_EL1.SHA1 == 0b0001.

HWCAP_SHA2
    SHA2 hash update accelerator.
    Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0001.

HWCAP_CRC32
    CRC32 instruction.
    Functionality implied by ID_AA64ISAR0_EL1.CRC32 == 0b0001.

HWCAP_ATOMICS
    Atomics instruction.
    Functionality implied by ID_AA64ISAR0_EL1.Atomic == 0b0010.

HWCAP_FPHP
    Instructions to convert between half-precision and single-precision, and between half-precision and double-precision.
    Functionality implied by ID_AA64PFR0_EL1.FP == 0b0001.

HWCAP_ASIMDHP
    Indicates whether the Advanced SIMD and Floating-point extension supports half-precision floating-point conversion operations.
    Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0001.

HWCAP_CPUID
    EL0 access to certain ID registers is available, to the extent
    described by Documentation/arm64/cpu-feature-registers.txt.
    These ID registers may imply the availability of features.

HWCAP_ASIMDRDM
    Indicates whether Rounding Double Multiply (RDM) instructions are implemented for Advanced SIMD.
    Functionality implied by ID_AA64ISAR0_EL1.RDM == 0b0001.

HWCAP_JSCVT
    ARMv8.3 adds support for a new instruction to perform conversion
    from double precision floating point to integer  to match the
    architected behaviour of the equivalent Javascript conversion.
    Functionality implied by ID_AA64ISAR1_EL1.JSCVT == 0b0001.

HWCAP_FCMA
    ARM v8.3 adds support for new instructions to aid floating-point
    multiplication and addition of complex numbers.
    Functionality implied by ID_AA64ISAR1_EL1.FCMA == 0b0001.

HWCAP_LRCPC
    ARMv8.3 adds new instructions to support Release Consistent
    processor consistent (RCpc) model, which is weaker than the
    RCsc model.
    Functionality implied by ID_AA64ISAR1_EL1.LRCPC == 0b0001.

HWCAP_DCPOP
    The ARMv8.2-DCPoP feature introduces persistent memory support to the
    architecture, by defining a point of persistence in the memory
    hierarchy, and a corresponding cache maintenance operation, DC CVAP.
    Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0001.

HWCAP_SHA3
    Secure Hash Standard3 (SHA3)
    Functionality implied by ID_AA64ISAR0_EL1.SHA3 == 0b0001.

HWCAP_SM3
    Commercial Cryptography Scheme.
    Functionality implied by ID_AA64ISAR0_EL1.SM3 == 0b0001.

HWCAP_SM4
    Commercial Cryptography Scheme.
    Functionality implied by ID_AA64ISAR0_EL1.SM4 == 0b0001.

HWCAP_ASIMDDP
    Performing dot product of 8bit elements in each 32bit element
    of two vectors and accumulating the result into a third vector.
    Functionality implied by ID_AA64ISAR0_EL1.DP == 0b0001.

HWCAP_SHA512
    Secure Hash Standard
    Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0002.

HWCAP_SVE
    Scalable Vector Extension (SVE) is a vector extension for
    AArch64 execution mode for the A64 instruction set of the Armv8 architecture.
    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001.

2. ARM64 Memory Partitioning and Monitoring (MPAM)
--------------------------------------------------
Armv8.4-A adds a feature called Memory Partitioning and Monitoring (MPAM). This has several uses.
Some system designs require running multiple applications or multiple virtual machines concurrently on a system
where the memory system is shared and where the performance of some applications or some virtual machines must
be only minimally affected by other applications or virtual machines. These scenarios are common in enterprise
networking and server systems.
This proposal addresses these scenarios with two approaches that work together under software control:
- Memory/Cache system resource partitioning
- Performance resource monitoring

3. Arm Power State Coordination Interface (PSCI)
------------------------------------------------
PSCI has the following intended uses:
- Provides a generic interface that supervisory software can use to
manage power in the following situations:
- Core idle management.
- Dynamic addition of cores to and removal of cores from the
system, often referred to as hotplug.
- Secondary core boot.
- Moving trusted OS context from one core to another.
- System shutdown and reset.
- Provides an interface that supervisory software can use in conjunction
with Firmware Table (FDT and ACPI) descriptions to support the
generalization of power management code.

4. Arm TrustZone
----------------
Arm TrustZone technology provides system-wide hardware isolation for trusted software.
The family of TrustZone technologies can be integrated into any Arm Cortex-A core,
supporting high-performance applications processors, with TrustZone technology for Cortex-A processors.

5. Arm CPU Info Detection
-------------------------
Computing resources should be collected by NFV COE, such as:
- Arm specific:
  CPU Part: indicates the primary part number.
            For example:
            0xD09	Cortex-A73 processor.

  CPU Architecture: indicates the architecture code.
	    For example:
	    0xF	Defined by CPUID scheme.

  CPU Variant: indicates the variant number of the processor.
            This is the major revision number n in the rn part of
            the rnpn description of the product revision status.

  CPU Implementer: indicates the implementer code.
            For example:
            0x41	ASCII character 'A' - implementer is ARM Limited.

  CPU Revision: indicates the minor revision number of the processor.
            This is the minor revision number n in the pn part of
            the rnpn description of the product revision status.
