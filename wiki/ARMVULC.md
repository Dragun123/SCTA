"Vulcan": Rapid Fire Plasma Cannon
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Vulcan unit icon" src="icons/units/ARMVULC_icon.png" />Vulcan<br />Rapid Fire Plasma Cannon
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
            <td><code>armvulc</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T4.png" title="Experimental" /> 4 (Experimental)</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 1400</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>ExperimentalStructure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 479111</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 45198</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>587421 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>14</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Vulcan" is an ARM structure unit included in *SCTATest*.
It is classified as a rapid fire plasma cannon unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#construction">Construction</a>
2. – <a href="#order-capabilities">Order capabilities</a>
3. – <a href="#weapons">Weapons</a>
</details>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 1:37:54 ‒ <img src="icons/energy.png" title="Energy" /> 82/s ‒ <img src="icons/mass.png" title="Mass" /> 8/s — Built by <a href="ARMACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 1:01:11 ‒ <img src="icons/energy.png" title="Energy" /> 130/s ‒ <img src="icons/mass.png" title="Mass" /> 12/s — Built by <a href="ARMACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 48:57 ‒ <img src="icons/energy.png" title="Energy" /> 163/s ‒ <img src="icons/mass.png" title="Mass" /> 15/s — Built by <a href="ARMACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 16:19:02 ‒ <img src="icons/energy.png" title="Energy" /> 8/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 4:04:45 ‒ <img src="icons/energy.png" title="Energy" /> 33/s ‒ <img src="icons/mass.png" title="Mass" /> 3/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
</table>

### Weapons
<details>
<summary>ARMVULC_WEAPON</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>800 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>800 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>4</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>193</td>
        </tr>
        <tr>
            <td align="right"><strong>Min range:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 0.2s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 2000 (2000/s for 1.0s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Artillery shield blocks<br />Damage friendly</td>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.EXPERIMENTAL">EXPERIMENTAL</a> · <a href="_categories.DIRECTFIRE">DIRECTFIRE</a> · <a href="_categories.ARTILLERY">ARTILLERY</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
