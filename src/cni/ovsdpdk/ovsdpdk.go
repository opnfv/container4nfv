// Copyright 2017 4 CNI authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"runtime"
        "os/exec"
	"github.com/containernetworking/cni/pkg/skel"
	"github.com/containernetworking/cni/pkg/types"
	"github.com/containernetworking/cni/pkg/types/current"
	"github.com/containernetworking/cni/pkg/version"
	"github.com/containernetworking/plugins/pkg/ipam"
)

const defaultBrName = "br-dpdk"

type NetConf struct {
	types.NetConf
	BrName       string `json:"bridge"`
}

func init() {
	// this ensures that main runs only on main thread (thread group leader).
	// since namespace ops (unshare, setns) are done for a single thread, we
	// must ensure that the goroutine does not jump from OS thread to thread
	runtime.LockOSThread()
}

func loadNetConf(bytes []byte) (*NetConf, string, error) {
	n := &NetConf{
		BrName: defaultBrName,
	}
	if err := json.Unmarshal(bytes, n); err != nil {
		return nil, "", fmt.Errorf("failed to load netconf: %v", err)
	}
	return n, n.CNIVersion, nil
}

func setupVhostUser(args *skel.CmdArgs, types string) error {
    exec.Command("/bin/bash", "/opt/cni/bin/setup_ovsdpdk.sh", args.Netns, args.ContainerID, types).Output()
    return nil
}

func cmdAdd(args *skel.CmdArgs) error {
	n, cniVersion, err := loadNetConf(args.StdinData)
	if err != nil {
		return err
	}

	// run the IPAM plugin and get back the config to apply
	r, err := ipam.ExecAdd(n.IPAM.Type, args.StdinData)
	if err != nil {
		return err
	}

	// Convert whatever the IPAM result was into the current Result type
	result, err := current.NewResultFromResult(r)
	if err != nil {
		return err
	}

	if len(result.IPs) == 0 {
		return errors.New("IPAM plugin returned missing IP config")
	}

        setupVhostUser(args, result.String())

        return types.PrintResult(result, cniVersion)
}

func tearDownVhostUser(args *skel.CmdArgs) error {
    exec.Command("/bin/bash", "/opt/cni/bin/teardown_ovsdpdk.sh", args.Netns, args.ContainerID).Output()
    return nil
}

func cmdDel(args *skel.CmdArgs) error {
        n, _, err := loadNetConf(args.StdinData)
        if err != nil {
                return err
        }

        if err := ipam.ExecDel(n.IPAM.Type, args.StdinData); err != nil {
                return err
        }

        tearDownVhostUser(args)
        return err
}

func main() {
	skel.PluginMain(cmdAdd, cmdDel, version.All)
}
