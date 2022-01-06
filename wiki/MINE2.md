"Area Mine": Tech 2 Medium Damage, Small Range Mine
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Area Mine unit icon" src="icons/units/MINE2_icon.png" />Area Mine<br />Tech 2 Medium Damage, Small Range Mine
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
            <td><code>mine2</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>CORE</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T2.png" title="Tech 2" /> 2</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 100</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 3000</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 500</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>3000</td>
        </tr>
        <tr>
            <td align="right"><strong>Maintenance cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 25/s</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>4</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Cloak</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Motion type:</strong></td>
            <td><code>RULEUMT_None</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Buildable layers:</strong></td>
            <td>Land</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Area Mine" is a CORE structure unit included in *SCTATest*.
It is classified as a tech 2 medium damage, small range mine unit. It has no defined build description, and no categories to define common builders.

<details>
<summary>Contents</summary>

1. – <a href="#abilities">Abilities</a>
2. – <a href="#construction">Construction</a>
3. – <a href="#order-capabilities">Order capabilities</a>
4. – <a href="#weapons">Weapons</a>
</details>

### Abilities
Hover over abilities to see effect descriptions.

* <span title="Can become hidden to visual sensors">Cloaking</span>
* <span title="Has a single-use self-damaging weapon">Suicide Weapon</span>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 00:30 ‒ <img src="icons/energy.png" title="Energy" /> 100/s ‒ <img src="icons/mass.png" title="Mass" /> 17/s — Built by <a href="ARMMLV">Tech 1 Mine Layer Vehicle</a>
* <img src="icons/time.png" title="Time" /> 00:30 ‒ <img src="icons/energy.png" title="Energy" /> 100/s ‒ <img src="icons/mass.png" title="Mass" /> 17/s — Built by <a href="CORMLV">Tech 1 Mine Layer Vehicle</a>
* <img src="icons/time.png" title="Time" /> 00:16 ‒ <img src="icons/energy.png" title="Energy" /> 180/s ‒ <img src="icons/mass.png" title="Mass" /> 30/s — Built by <a href="ARMFARK">Tech 2 Fast Assist-Repair Kbot</a>
* <img src="icons/time.png" title="Time" /> 00:16 ‒ <img src="icons/energy.png" title="Energy" /> 180/s ‒ <img src="icons/mass.png" title="Mass" /> 30/s — Built by <a href="CORNECRO">Tech 2 Resurrection Kbot</a>

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
<tr>
<td><img float="left" src="icons/orders/toggle-weapon.png" title="error:Detonate no title" /></td>
<td><img float="left" src="icons/orders/intel-counter.png" title="Personal Cloak
Turn the selected units cloaking on/off" /></td>
</table>

### Weapons
<details>
<summary>MINE</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>500 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>500 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>3</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>2</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 1.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
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
            <td>4</td>
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
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.CORE">CORE</a> · <a href="_categories.TECH2">TECH2</a> · <a href="_categories.DIRECTFIRE">DIRECTFIRE</a> · <a href="_categories.LAND">LAND</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
