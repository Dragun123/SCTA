"Commander": Tech 2 Commander
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Commander unit icon" src="icons/units/ARMDECOM_icon.png" />Commander<br />Tech 2 Commander
            </th>
        </tr>
    </thead>
    <tbody>
        <tr><td align="center" colspan="2">Note: Several units have stats defined at the<br />start of the game based on the stats of others.</td></tr>
        <tr>
            <td align="right"><strong>Source:</strong></td>
            <td><a href="SCTATest">SCTATest</a></td>
        </tr>
        <tr>
            <td align="right"><strong>Unit ID:</strong></td>
            <td><code>armdecom</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T2.png" title="Tech 2" /> 2</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 3000 (+0/s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 11561</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 721</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>24048</td>
        </tr>
        <tr>
            <td align="right"><strong>Maintenance cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 100/s</td>
        </tr>
        <tr>
            <td align="right"><strong>Build rate:</strong></td>
            <td><img src="icons/build.png" title="Build" /> 30</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>18</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Radar radius:</strong></td>
            <td>25</td>
        </tr>
        <tr>
            <td align="right"><strong>Sonar radius:</strong></td>
            <td>25</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Cloak</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_Amphibious</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Movement speed:</strong></td>
            <td>2.25</td>
        </tr>
        <tr>
            <td align="right"><strong>Transport class:</strong></td>
            <td><img src="icons/attached.png" title="Attached" /> Medium</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>4 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Commander" is an ARM seabed amphibious unit included in *SCTATest*.
It is classified as a tech 2 commander unit. It has no defined build description, and no categories to define common builders.

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#engineering">Engineering</a>
5. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Can become hidden to visual sensors">Cloaking</span>
* <span title="Can pass land and water">Amphibious</span>
* <span title="error:description">D-Gun</span>
* <span title="Has complete engineering features">Engineering Suite</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 02:00 ‒ <img src="icons/energy.png" title="Energy" /> 96/s ‒ <img src="icons/mass.png" title="Mass" /> 6/s — Built by <a href="ARMALAB">Tech 2 Produces Kbots</a>

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/move.png" title="Move" /></td>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/patrol.png" title="Patrol" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/guard.png" title="Assist" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
<tr>
<td><img float="left" src="icons/orders/activate-weapon.png" title="error:Decoy DGun. Requires 500 Energy to Fire. Right-click turn on auto no title" /></td>
<td><img float="left" src="icons/orders/load.png" title="Call Transport
Load into or onto another unit" /></td>
<td><img float="left" src="icons/orders/reclaim.png" title="Reclaim" /></td>
<td><img float="left" src="icons/orders/convert.png" title="Capture" /></td>
<td><img float="left" src="icons/orders/intel-counter.png" title="Personal Cloak
Turn the selected units cloaking on/off" /></td>
<td><img float="left" src="icons/orders/repair.png" title="Repair" /></td>
<td><img float="left" src="icons/orders/pause.png" title="Pause Construction
Pause/unpause current construction order" /></td>
</table>

### Engineering
The engineering capabilties of this unit consist of the ability to capture, reclaim, and repair.
It has the build category <code>BUILTBYCOMMANDER ARM</code>. 
<details>
<summary>This build category allows it to build the following mod units:

</summary>

<table>
    <tr>
        <td rowspan="2"><img src="icons/T1.png" title="T1" /></td>
        <td><a href="ARMLAB"><img src="icons/units/ARMLAB_icon.png" width="64px" /></a></td>
        <td><a href="ARMVP"><img src="icons/units/ARMVP_icon.png" width="64px" /></a></td>
        <td><a href="ARMSY"><img src="icons/units/ARMSY_icon.png" width="64px" /></a></td>
        <td><a href="ARMAP"><img src="icons/units/ARMAP_icon.png" width="64px" /></a></td>
        <td><a href="ARMMAKR"><img src="icons/units/ARMMAKR_icon.png" width="64px" /></a></td>
        <td><a href="ARMMEX"><img src="icons/units/ARMMEX_icon.png" width="64px" /></a></td>
        <td><a href="ARMMSTOR"><img src="icons/units/ARMMSTOR_icon.png" width="64px" /></a></td>
        <td><a href="ARMTIDE"><img src="icons/units/ARMTIDE_icon.png" width="64px" /></a></td>
    </tr>
    <tr>
        <td><a href="ARMESTOR"><img src="icons/units/ARMESTOR_icon.png" width="64px" /></a></td>
        <td><a href="ARMTL"><img src="icons/units/ARMTL_icon.png" width="64px" /></a></td>
        <td><a href="ARMRAD"><img src="icons/units/ARMRAD_icon.png" width="64px" /></a></td>
        <td><a href="ARMSONAR"><img src="icons/units/ARMSONAR_icon.png" width="64px" /></a></td>
    </tr>
</table>

</details>


### Weapons
<details>
<summary>COMLASER</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><error:Weapon hits high alt air and other stuff></td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>200 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>100 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>22</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 0.5s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>OverCharge</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>5 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>10 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>1.5</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>DGun</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>22</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 2.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 500 (500/s for 1.0s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>AutoOverCharge</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>3 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>10 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>1.5</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>DGun</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>22</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 2.9s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 500 (500/s for 1.0s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>DeathWeapon</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>1000</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>20</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Deathnuke</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>


<table align=center>
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH2">TECH2</a> · <a href="_categories.MOBILE">MOBILE</a> · <a href="_categories.DIRECTFIRE">DIRECTFIRE</a> · <a href="_categories.LAND">LAND</a> · <a href="_categories.SUBCOMMANDER">SUBCOMMANDER</a> · <a href="_categories.ENGINEER">ENGINEER</a>
