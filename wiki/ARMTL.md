"Torpedo Launcher": Tech 1 Torpedo Launcher
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Torpedo Launcher unit icon" src="icons/units/ARMTL_icon.png" />Torpedo Launcher<br />Tech 1 Torpedo Launcher
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
            <td><code>armtl</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T1.png" title="Tech 1" /> 1</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 500</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 2658</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 804</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>4120 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Sonar radius:</strong></td>
            <td>28</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Torpedo Launcher" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 1 torpedo launcher unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Has a weapon that can target things immersed in water">Torpedoes</span>
* <span title="Can see blips of units not seen by vision that are on or below water">Sonar</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 00:32 ‒ <img src="icons/energy.png" title="Energy" /> 81/s ‒ <img src="icons/mass.png" title="Mass" /> 24/s — Built by <a href="ARMCS">Tech 1 Tech Level 1</a>
* <img src="icons/time.png" title="Time" /> 02:17 ‒ <img src="icons/energy.png" title="Energy" /> 19/s ‒ <img src="icons/mass.png" title="Mass" /> 6/s — Built by <a href="ARMDECOM">Tech 2 Commander</a>
* <img src="icons/time.png" title="Time" /> 00:51 ‒ <img src="icons/energy.png" title="Energy" /> 52/s ‒ <img src="icons/mass.png" title="Mass" /> 16/s — Built by <a href="ARMCH">Tech 3 Tech Level 3</a>
* <img src="icons/time.png" title="Time" /> 01:22 ‒ <img src="icons/energy.png" title="Energy" /> 32/s ‒ <img src="icons/mass.png" title="Mass" /> 10/s — Built by <a href="ARMCSA">Tech 3 Tech Level 3</a>
* <img src="icons/time.png" title="Time" /> 06:52 ‒ <img src="icons/energy.png" title="Energy" /> 6/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by Armoured Command Unit
* <img src="icons/time.png" title="Time" /> 02:17 ‒ <img src="icons/energy.png" title="Energy" /> 19/s ‒ <img src="icons/mass.png" title="Mass" /> 6/s — Built by Tech 2 Armoured Command Unit
* <img src="icons/time.png" title="Time" /> 04:34 ‒ <img src="icons/energy.png" title="Energy" /> 10/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by Tech 3 Engineer

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
</table>

### Weapons
<details>
<summary>COAX_TORPEDO</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Naval)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>150 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>300 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>25</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 2.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
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
            <td>75</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>5</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>


<table align=center>
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH1">TECH1</a> · <a href="_categories.ANTINAVY">ANTINAVY</a> · <a href="_categories.NAVAL">NAVAL</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
