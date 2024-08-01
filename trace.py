from bcc import BPF

# eBPF program
bpf_program = """
#include <uapi/linux/ptrace.h>

int trace_entry(struct pt_regs *ctx) {
    bpf_trace_printk("Function entry: %s\\n", __builtin_return_address(0));
    return 0;
}

int trace_exit(struct pt_regs *ctx) {
    bpf_trace_printk("Function exit: %s\\n", __builtin_return_address(0));
    return 0;
}
"""

# Initialize BPF
b = BPF(text=bpf_program)

# Attach eBPF program to the function
b.attach_uprobe(name="/usr/local/bin/webapp", sym="main.helloHandler", fn_name="trace_entry")
b.attach_uretprobe(name="/usr/local/bin/webapp", sym="main.helloHandler", fn_name="trace_exit")

# Print logs
b.trace_print()
